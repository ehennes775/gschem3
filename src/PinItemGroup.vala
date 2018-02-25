namespace Gschem3
{
    /**
     *
     */
    public class PinItemGroup : Object
    {
        /**
         * Redraw the current item
         */
        public signal void invalidate(Geda3.SchematicItem item);


        /**
         * An optional logic bubble
         */
        public Geda3.CircleItem? bubble
        {
            get
            {
                return b_bubble;
            }
            private set
            {
                if (b_bubble != null)
                {
                    invalidate(b_bubble);

                    b_bubble.invalidate.disconnect(on_invalidate);
                }

                b_bubble = value;

                if (b_bubble != null)
                {
                    b_bubble.invalidate.connect(on_invalidate);

                    invalidate(b_bubble);
                }
            }
        }


        /**
         * The pin within this group
         */
        public Geda3.SchematicItemPin pin
        {
            get
            {
                return b_pin;
            }
            private set
            {
                if (b_pin != null)
                {
                    invalidate(b_pin);

                    b_pin.invalidate.disconnect(on_invalidate);
                }

                b_pin = value;

                if (b_pin != null)
                {
                    b_pin.invalidate.connect(on_invalidate);

                    invalidate(b_pin);
                }
            }
        }


        /**
         * The settings for this group
         *
         * Setting this property to null will assign the default
         * pin tool settings.
         */
        public PinSettings settings
        {
            get
            {
                return b_settings;
            }
            set
            {
                if (b_settings != null)
                {
                    b_settings.notify["pin-type"].disconnect(
                        on_notify_pin_type
                        );

                    b_settings.notify["use-bubble"].disconnect(
                        on_notify_use_bubble
                        );
                }

                b_settings = value ?? PinSettings.get_default();

                b_settings.notify["pin-type"].connect(
                    on_notify_pin_type
                    );

                b_settings.notify["use-bubble"].connect(
                    on_notify_use_bubble
                    );
            }
            default = null;
        }


        /**
         * Create a new pin drawing tool
         *
         * @param window The document window this tool is drawing into
         */
        private PinItemGroup(PinSettings settings, int x, int y)
        {
            this.settings = settings;

            m_x[0] = x;
            m_y[0] = y;
            m_x[2] = x;
            m_y[2] = y;

            bubble = b_settings.create_bubble(
                m_x[0],
                m_y[0],
                m_x[2],
                m_y[2]
                );

            pin = new Geda3.SchematicItemPin.with_points(
                m_x[0],
                m_y[0],
                m_x[2],
                m_y[2]
                );

            pin.pin_type = b_settings.pin_type;

            pin.attach(new Geda3.TextItem.as_attribute(
                m_x[2] + 50,
                m_y[2],
                "pinlabel",
                "RESET",
                Geda3.Visibility.VISIBLE,
                Geda3.TextPresentation.VALUE,
                Geda3.TextAlignment.MIDDLE_LEFT,
                0,
                Geda3.Color.TEXT
                ));

            pin.attach(new Geda3.TextItem.as_attribute(
                m_x[2] - 50,
                m_y[2] + 50,
                "pinnumber",
                "13",
                Geda3.Visibility.VISIBLE,
                Geda3.TextPresentation.VALUE,
                Geda3.TextAlignment.LOWER_RIGHT,
                0,
                Geda3.Color.ATTRIBUTE,
                8
                ));

            pin.attach(new Geda3.TextItem.as_attribute(
                m_x[0] - 50,
                m_y[0] + 50,
                "pinseq",
                "13",
                Geda3.Visibility.INVISIBLE,
                Geda3.TextPresentation.BOTH,
                Geda3.TextAlignment.LOWER_RIGHT,
                0,
                Geda3.Color.ATTRIBUTE,
                10
                ));

            pin.attach(new Geda3.TextItem.as_attribute(
                m_x[0] - 600,
                m_y[0] + 50,
                "pintype",
                "pas",
                Geda3.Visibility.INVISIBLE,
                Geda3.TextPresentation.BOTH,
                Geda3.TextAlignment.LOWER_RIGHT,
                0,
                Geda3.Color.ATTRIBUTE,
                10
                ));

            update(m_x[2], m_y[2]);
        }


        public PinItemGroup.standard(PinSettings settings, int x, int y)
        {
            this(settings, x, y);
        }


        /**
         *
         *
         */
        public PinItemGroup.terminal(PinSettings settings, int x, int y)
        {
            this(settings, x, y);
        }


        /**
         * {@inheritDoc}
         */
        public void draw(Geda3.SchematicPainterCairo painter, bool reveal, bool selected)

            requires(b_pin != null)

        {
            b_pin.draw(painter, reveal, selected);

            if (b_bubble != null)
            {
                b_bubble.draw(painter, reveal, selected);
            }
        }


        /**
         *
         * @param x
         * @param y
         */
        public void update(int x, int y)
        {
            m_x[2] = x;
            m_y[2] = y;

            m_x[1] = m_x[2];
            m_y[1] = m_y[2];

            if (b_bubble != null)
            {
                b_bubble.locate_bubble(m_x[0], m_y[0], ref m_x[1], ref m_y[1]);
            }

            m_updater.update(b_pin, m_x, m_y);
        }


        /**
         * The backing store for the optional logic bubble
         */
        private Geda3.CircleItem? b_bubble;


        /**
         * The backing store for the pin
         */
        private Geda3.SchematicItemPin b_pin;


        /**
         * Backing store for the settings
         */
        private PinSettings b_settings;


        /**
         * Temporarily keeping the updater here for development
         */
        private PinUpdater m_updater = new PinUpdater();


        /**
         * The x coordinate of the last updates in document coordinates
         */
        private int m_x[3];


        /**
         * The y coordinate of the last updates in document coordinates
         */
        private int m_y[3];


        /**
         * Redraw one of the items in this group
         */
        private void on_invalidate(Geda3.SchematicItem item)

            requires(item != null)

        {
            invalidate(item);
        }


        /**
         *
         */
        private void on_notify_pin_type(ParamSpec param)

            requires(b_settings != null)

        {
            b_pin.pin_type = b_settings.pin_type;
            
            update(m_x[2], m_y[2]);
        }


        /**
         *
         */
        private void on_notify_use_bubble(ParamSpec param)

            requires(b_settings != null)

        {
            if (!b_settings.use_bubble)
            {
                bubble = null;
            }
            else if (bubble == null)
            {
                bubble = b_settings.create_bubble(
                    m_x[0],
                    m_y[0],
                    m_x[2],
                    m_y[2]
                    );
            }
            
            update(m_x[2], m_y[2]);
        }
    }
}
