namespace Gschem3
{
    /**
     *
     */
    public class DrawingToolSelect : DrawingTool
    {
        public DrawingToolSelect(SchematicWindow window)
        {
            m_gripped = null;
            m_grips = null;
            m_selected = Gee.Set<Geda3.SchematicItem>.empty();
            m_state = State.S0;
            m_window = window;
        }


        /**
         * {@inheritDoc}
         */
        public override bool button_pressed(Gdk.EventButton event)

            requires(m_window != null)

        {
            if (m_state == State.S0)
            {
                m_selected = new Gee.HashSet<Geda3.SchematicItem>();

                m_selected.add_all(m_window.schematic.items);

                m_gripped = null;

                foreach (var item in m_selected)
                {
                    var grippable = item as Geda3.Grippable;

                    if (grippable != null)
                    {
                        m_gripped = grippable;
                        break;
                    }
                }

                if (m_gripped != null)
                {
                    m_grips = m_gripped.create_grips();
                }

                invalidate();
            }
            else
            {
                return_val_if_reached(false);
            }

            return true;
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(Geda3.SchematicPainter painter)
        {
            if (m_gripped != null)
            {
                m_gripped.draw(painter, true);
            }

            if (m_grips != null)
            {
                foreach (var grip in m_grips)
                {
                    grip.draw(painter);
                }
            }
        }


        /**
         * States of the drawing tool
         */
        private enum State
        {
            S0,
            S1
        }


        /**
         *
         */
        private Gee.Collection<Geda3.Grip> m_grips;


        /**
         *
         */
        private Geda3.Grippable m_gripped;


        /**
         *
         */
        private Gee.Set<Geda3.SchematicItem> m_selected;


        /**
         * Stores the current state of the tool
         */
        private State m_state;


        /**
         * Stores the document window this tool is drawing into
         */
        private weak SchematicWindow m_window;


        /**
         * Redraw the current item
         */
        private void invalidate()

            requires(m_window != null)

        {
            if (m_gripped != null)
            {
                m_window.invalidate_item(m_gripped);
            }
        }
    }
}
