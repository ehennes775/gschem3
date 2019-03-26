namespace Gschem3
{
    /**
     *
     *
     */
    public class DrawingToolSet
    {
        /**
         *
         *
         * @param factory
         */
        public DrawingToolSet(ComplexFactory factory)
        {
            m_tools = new Gee.HashMap<string,DrawingTool>();

            DrawingTool[] tools =
            {
                new ArcTool(),
                new BoxTool(),
                new BusTool(),
                new CircleTool(),
                new ComplexTool(null, factory),
                new LineTool(),
                new NetTool(),
                new PathTool(),
                new PinTool(),
                new SelectTool(),
                new ZoomTool()
            };

            foreach (var tool in tools)
            {
                add(tool);
            }

            m_current_tool = m_tools[SelectTool.NAME];
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
        }


        /**
         * Set the current document window for the tools
         *
         * @param window The current document window
         */
        public void update_document_window(DocumentWindow? window)

            requires(m_tools != null)

        {
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
         *
         * @param tool
         */
        private void add(DrawingTool tool)

            requires(m_tools != null)
            requires(tool.name != null)

        {
            remove(tool.name);

            m_tools.@set(tool.name, tool);

            tool.request_cancel.connect(on_request_cancel);
        }


        /**
         *
         *
         * @param sender
         */
        private void on_request_cancel(DrawingTool sender)

            requires(m_current_tool == sender)

        {
            select_tool(SelectTool.NAME);
        }


        /**
         *
         *
         * @param name
         */
        private void remove(string name)

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
