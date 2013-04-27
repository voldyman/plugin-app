namespace PlugApp
{
    public class App
    {
        private PluginManager manager;
        public signal void process_input (string inp);

        public App ()
        {
            manager = new PluginManager (this);
        }

        public void loop ()
        {
            string input = "";
            while (input != "quit")
            {
                stdout.printf ("\n> ");
                input = stdin.read_line ();
                process_input (input);
            }

        }

        public static void main ()
        {
            new App ().loop ();
        }
    }

    public class API : GLib.Object
    {
        public App app;

        public API (App app)
        {
            this.app = app;
        }

    }

    public class PluginManager
    {
        private App app;
        Peas.Engine engine;
        Peas.ExtensionSet exts;

        public API plugin_iface { private set; public get; }

        public PluginManager (App app)
        {
            this.app = app;
            plugin_iface = new API (app);

            engine = Peas.Engine.get_default ();
            engine.enable_loader ("python");
            engine.enable_loader ("gjs");
            engine.add_search_path (".", null);

            /* Our extension set */
            Parameter param = Parameter();
            param.value = plugin_iface;
            param.name = "object";
            exts = new Peas.ExtensionSet (engine, typeof(Peas.Activatable), "object", plugin_iface, null);
            // Load all the plugins found
            foreach (var plug in engine.get_plugin_list ()) {
                if (engine.try_load_plugin (plug)) {
                    debug ("Plugin Loaded:" +plug.get_name ());
                } else {
                    warning ("Could not load plugin:" +plug.get_name ());
                }
            }

            exts.extension_removed.connect(on_extension_removed);
            exts.foreach (extension_foreach);

        }

        void extension_foreach (Peas.ExtensionSet set, Peas.PluginInfo info, Peas.Extension extension) {
            debug ("Extension added");
            ((Peas.Activatable) extension).activate ();
        }

        void on_extension_removed (Peas.PluginInfo info, Object extension) {
            ((Peas.Activatable) extension).deactivate ();
        }
    }
}
