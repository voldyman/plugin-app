using PlugApp;

public class Really : Peas.ExtensionBase,  Peas.Activatable
{
    PlugApp.API plugins;
    public Object object { owned get; construct; }

    public void activate ()
    {
        plugins = (PlugApp.API) object;
        plugins.app.process_input.connect ((str) => {
            print ("really? "+str);
        });
    }

    public void deactivate ()
    {

    }
    public void update_state ()
    {

    }
}

[ModuleInit]
public void peas_register_types (GLib.TypeModule module)
{
    var objmodule = module as Peas.ObjectModule;
    objmodule.register_extension_type (typeof (Peas.Activatable),
                                       typeof (Really));
}
