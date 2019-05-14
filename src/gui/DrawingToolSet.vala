namespace Gschem3
{
    /**
     *
     *
     */
    public class DrawingToolSet : Object,
        SchematicPasteHandler
    {
        /**
         *
         * @param name The name of the selected tool
         */
        public signal void tool_selected(string name);


        /**
         *
         *
         * @param factory
         */
        public DrawingToolSet(ComplexSelector selector)
        {
            m_tools = new Gee.HashMap<string,DrawingTool>();

            DrawingTool[] tools =
            {
                new ArcTool(),
                new BoxTool(),
                new BusTool(),
                new CircleTool(),
                new ComplexTool(selector),
                new LineTool(),
                new NetTool(),
                new PathTool(),
                new PinTool(),
                new SelectTool(),
                new ZoomTool()
            };

            foreach (var tool in tools)
            {
                add_tool(tool);
            }

            m_current_tool = m_tools[SelectTool.NAME];
        }


        /**
         * Process a mouse button press event
         *
         * @param event The GDK button event triggering this call
         * @return This funtion returns TRUE when this function handles
         * the event. This function returns FALSE if this event must
         * continue propagation.
         */
        public bool button_pressed(Gdk.EventButton event)

            requires(m_current_tool != null)

        {
            return m_current_tool.button_pressed(event);
        }


        /**
         * Process a mouse button release event
         *
         * @param event The GDK button event triggering this call
         * @return This funtion returns TRUE when this function handles
         * the event. This function returns FALSE if this event must
         * continue propagation.
         */
        public bool button_released(Gdk.EventButton event)

            requires(m_current_tool != null)

        {
            return m_current_tool.button_released(event);
        }


        /**
         * Process a keyboard key press event
         *
         * @param event The GDK button event triggering this call
         * @return This funtion returns TRUE when this function handles
         * the event. This function returns FALSE if this event must
         * continue propagation.
         */
        public bool key_pressed(Gdk.EventKey event)

            requires(m_current_tool != null)

        {
            return m_current_tool.key_pressed(event);
        }


        /**
         * Process a keyboard key release event
         *
         * @param event The GDK button event triggering this call
         * @return This funtion returns TRUE when this function handles
         * the event. This function returns FALSE if this event must
         * continue propagation.
         */
        public bool key_released(Gdk.EventKey event)

            requires(m_current_tool != null)

        {
            return m_current_tool.key_released(event);
        }


        /**
         * {@inheritDoc}
         */
        public void paste()
        {
            select_tool(SelectTool.NAME);
        }


        /**
         * Select a drawing tool by name
         *
         * The m_current_tool should not be null, but this function
         * would need to execute to correct the issue. Otherwise, the
         * value would be 'stuck' at null. So, this function treats
         * m_current_tool equal to null as a valid precondition.
         *
         * @param name The name of the tool to select
         */
        public void select_tool(string name)

            requires(m_tools != null)
            requires(m_tools.has_key(name))
            ensures(m_current_tool != null)

        {
            if (m_current_tool != null)
            {
                m_current_tool.cancel();
            }

            m_current_tool = m_tools[name];

            return_if_fail(m_current_tool != null);

            m_current_tool.reset();

            tool_selected(name);
        }


        /**
         * Select a drawing tool and start an operation
         *
         * The m_current_tool should not be null, but this function
         * would need to execute to correct the issue. Otherwise, the
         * value would be 'stuck' at null. So, this function treats
         * m_current_tool equal to null as a valid precondition.
         *
         * @param name The name of the tool to select
         * @param x The x coordinate to start the tool operation
         * @param y The y coordinate to start the tool operation
         */
        public void select_tool_with_point(string name, double x, double y)

            requires(m_tools != null)
            requires(m_tools.has_key(name))
            ensures(m_current_tool != null)

        {
            if (m_current_tool != null)
            {
                m_current_tool.cancel();
            }

            m_current_tool = m_tools[name];

            return_if_fail(m_current_tool != null);

            m_current_tool.reset_with_point(x, y);

            tool_selected(name);
        }


        /**
         * Set the current document window for the tools
         *
         * @param window The current document window
         */
        public void update_document_window(DocumentWindow? window)

            requires(m_tools != null)

        {
            if (m_window != null)
            {
                m_window.tool_button_press_event.disconnect(
                    on_tool_button_press_event
                    );
                
                m_window.tool_button_release_event.disconnect(
                    on_tool_button_release_event
                    );

                m_window.tool_key_press_event.disconnect(
                    on_tool_key_press_event
                    );

                m_window.tool_key_release_event.disconnect(
                    on_tool_key_release_event
                    );

                m_window.tool_motion_notify_event.disconnect(
                    on_tool_motion_notify_event
                    );

                m_window.draw_tool.disconnect(on_draw_tool);
            }

            m_window = window as SchematicWindow;

            foreach (var tool in m_tools.entries)
            {
                if (tool.@value != null)
                {
                    tool.@value.update_document_window(window);
                }
                else
                {
                    warn_if_fail(tool.@value != null);
                }
            }

            if (m_window != null)
            {
                m_window.tool_button_press_event.connect(
                    on_tool_button_press_event
                    );
                    
                m_window.tool_button_release_event.connect(
                    on_tool_button_release_event
                    );
                
                m_window.tool_key_press_event.connect(
                    on_tool_key_press_event
                    );
                
                m_window.tool_key_release_event.connect(
                    on_tool_key_release_event
                    );
                
                m_window.tool_motion_notify_event.connect(
                    on_tool_motion_notify_event
                    );

                m_window.draw_tool.connect(on_draw_tool);
            }
        }


        /**
         * The current drawing tool
         */
        private DrawingTool m_current_tool;


        /**
         * The drawing tools for this window
         */
        private Gee.HashMap<string,DrawingTool> m_tools;


        /**
         *
         */
        private SchematicWindow? m_window;


        /**
         * Add a tool to the set
         *
         * If a tool exists with the same name, the tool is replaced.
         *
         * @param tool The tool to add to the set
         */
        private void add_tool(DrawingTool tool)

            requires(m_tools != null)
            requires(tool.name != null)

        {
            remove_tool(tool.name);

            m_tools.@set(tool.name, tool);

            tool.request_cancel.connect(on_request_cancel);
        }


        /**
         *
         *
         * @param sender The tool sending the cancel request
         */
        private void on_request_cancel(DrawingTool sender)

            requires(m_current_tool == sender)

        {
            select_tool(SelectTool.NAME);
        }


        /**
         *
         */
        private bool on_tool_button_press_event(Gdk.EventButton event)
        {
            return button_pressed(event);
        }


        /**
         *
         */
        private bool on_tool_button_release_event(Gdk.EventButton event)
        {
            return button_released(event);
        }


        /**
         *
         */
        private bool on_tool_key_press_event(Gdk.EventKey event)
        {
            return key_pressed(event);
        }


        /**
         *
         */
        private bool on_tool_key_release_event(Gdk.EventKey event)
        {
            return key_released(event);
        }


        /**
         *
         */
        private bool on_tool_motion_notify_event(Gdk.EventMotion event)

            requires(m_current_tool != null)

        {
            return m_current_tool.motion_notify(event);
        }

        /**
         *
         *
         * @param context
         */
        private void on_draw_tool(SchematicWindow sender, Geda3.SchematicPainter context)

            requires(m_current_tool != null)

        {
            m_current_tool.draw(context);
        }


        /**
         * Remove a tool from the set
         *
         * If a tool with the given name is not present, this function
         * does nothing.
         *
         * @param name The name of the tool to remove from the set
         */
        private void remove_tool(string name)

            requires(m_tools != null)

        {
            if (m_tools.has_key(name))
            {
                var tool = m_tools[name];

                tool.request_cancel.disconnect(on_request_cancel);

                m_tools.unset(name);
            }
        }
    }
}
