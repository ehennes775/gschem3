namespace GedaTest.SchematicReader
{
    void check_peek_token()
    {
        try
        {
            for (int index = 0; index < records.length; index++)
            {
                var input = records[index].input;

                var input_stream = new DataInputStream(
                    new MemoryInputStream.from_data(input.data, null)
                    );

                var token = Geda3.SchematicReader.peek_token(input_stream);

                if (token != records[index].expected)
                {
                    stdout.printf("\n");
                    stdout.printf("    input    = '%s'\n", input);
                    stdout.printf("    output   = '%s'\n", token);
                    stdout.printf("    expected = '%s'\n", records[index].expected);
                }

                assert_true(token == records[index].expected);
            }
        }
        catch (Error error)
        {
            assert_not_reached();
        }
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/schematicreader/peektoken", check_peek_token);

        return Test.run();
    }


    private struct Record
    {
        public string input;
        public string? expected;
    }


    private const Record records[] =
    {
        { "",          null      },
        { " ",         null      },
        { "\t",        null      },
        { "\r",        null      },
        { "\n",        null      },
        { "  \n",      null      },
        { "A",         "A"       },
        { "A ",        "A"       },
        { " A",        "A"       },
        { " A ",       "A"       },
        { "\u2126",    "\u2126"  },
        { "\u2126 ",   "\u2126"  },
        { " \u2126",   "\u2126"  },
        { " \u2126 ",  "\u2126"  },
        { "LINE",      "LINE"    },
        { "LINE ",     "LINE"    },
        { " LINE",     "LINE"    },
        { " LINE ",    "LINE"    },
    };

}
