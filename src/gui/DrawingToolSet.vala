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
         */
        public DrawingToolSet(ComplexFactory factory)
        {
            m_tools = new Gee.HashMap<string,DrawingTool>();

            m_tools.@set(DrawingTool.ArcName, new ArcTool(null));
            m_tools.@set(DrawingTool.BoxName, new DrawingToolBox(null));
            m_tools.@set(DrawingTool.BusName, new DrawingToolBus(null));
            m_tools.@set(DrawingTool.CircleName, new DrawingToolCircle(null));
            m_tools.@set(DrawingTool.ComplexName, new ComplexTool(null,factory));
            m_tools.@set(DrawingTool.LineName, new LineTool(null));
            m_tools.@set(DrawingTool.NetName, new DrawingToolNet(null));
            m_tools.@set(DrawingTool.PathName, new DrawingToolPath(null));
            m_tools.@set(DrawingTool.PinName, new PinTool(null));
            m_tools.@set(DrawingTool.SELECT_NAME, new DrawingToolSelect(null));
            m_tools.@set(DrawingTool.ZOOM_NAME, new ZoomTool(null));

            m_current_tool = m_tools[DrawingTool.SELECT_NAME];
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
    }
}
