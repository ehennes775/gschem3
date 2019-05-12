namespace Gschem3
{
    /**
     *
     */
    public class ClipboardHelper : Object
    {
        /**
         * Place items in the clipboard
         *
         * @param clipbaord The clipboard to receive the items
         * @param items The items to place in the clipboard
         */
        public static void clip(
            Gtk.Clipboard clipboard,
            Gee.Collection<Geda3.SchematicItem> items
            )
        {
            stdout.printf("clip\n");

            clipboard.clear();

            var helper = new ClipboardHelper.with_items(items);

            clipboard.set_with_owner(
                targets,
                clipboard_get,
                clipboard_clear,
                helper.@ref()
                );
        }


        /**
         * Contains the clipboard data
         *
         * Using Bytes instead of uint8[] -- MemoryOutputStream wasn't
         * transferring the length of the array to the return value
         * when using steal_data().
         */
        private Bytes m_bytes;


        /**
         * Create a new instance
         *
         * @param items The schematic items to place in the clipboard
         */
        private ClipboardHelper.with_items(
            Gee.Collection<Geda3.SchematicItem> items
            )
        {
            var memory_stream = new MemoryOutputStream.resizable();
            var output_stream = new DataOutputStream(memory_stream);

            foreach (var item in items)
            {
                item.write(output_stream);

                var parent = item as Geda3.AttributeParent;

                if (parent != null)
                {
                    output_stream.put_string("{\n");

                    foreach (var child in parent.attributes)
                    {
                        child.write(output_stream);
                    }

                    output_stream.put_string("}\n");
                }
            }

            output_stream.close();

            m_bytes = memory_stream.steal_as_bytes();
        }


        /**
         * Supported targets
         */
        private const Gtk.TargetEntry[] targets =
        {
            { "application/x-lepton-schematic", 0, 1 }
        };


        /**
         * Place the data into the clipboard
         *
         * @param clipboard The clipboard
         * @param selection_data The selection to receive the data
         * @param info The number from the TargetEntry[] array
         * @param owner The helper object
         */
        private static void clipboard_get(
            Gtk.Clipboard clipboard,
            Gtk.SelectionData selection_data,
            uint info,
            void* owner
            )

        {
            var helper = owner as ClipboardHelper;
            return_if_fail(helper != null);
            return_if_fail(helper.m_bytes != null);

            var type = Gdk.Atom.intern(
                "application/x-lepton-schematic",
                false
                );

            selection_data.@set(type, 8, helper.m_bytes.get_data());
        }


        /**
         * Free the clipboard data
         *
         * @param clipboard The clipboard
         * @param owner The helper object
         */
        private static void clipboard_clear(
            Gtk.Clipboard clipboard,
            void* owner
            )
        {
            var helper = owner as ClipboardHelper;
            return_if_fail(helper != null);

            helper.unref();
        }
    }
}
