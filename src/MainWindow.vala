/*  
*   Copyright (c) 2017-2020 kmal-kenneth (https://github.com/kmal-kenneth)
*
*   This file is part of Monilet.
*
*   Monilet is free software: you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation, either version 3 of the License, or
*   (at your option) any later version.
*
*   Monilet is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with Monilet.  If not, see <https://www.gnu.org/licenses/>.  
*
*   Authored by: Kenet Mauricio Acuña Lago <kmal.kenneth@live.com>
*/

using Gtk;

namespace Monilet {

    public class MainWindow : Gtk.Dialog {

        //Wigets
        WidgetCpu widget_cpu;
        WidgetMemory widget_memory;

        //monitoring services
        CPU cpu;
        Memory memory;

        //construct
        public MainWindow (Gtk.Application app) {
            Object (application: app,
                    icon_name: "com.github.kmal-kenneth.monilet",
                    resizable: false,
                    title: _("Monilet"),
                    height_request: 200,
                    width_request: 512);

            widget_cpu.cores = cpu.quantity_cores;
            update ();
        }

        //create ui
        construct {
            get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            set_keep_below (true);
            stick ();

            cpu = new CPU ();
            memory = new Memory ();
            widget_cpu = new WidgetCpu ();
            widget_memory = new WidgetMemory ();

            var grid = new Gtk.Grid ();
            grid.margin_bottom = 8;
            grid.margin_end = 18;
            grid.margin_start = 18;

            var spinner = new Gtk.Spinner ();
            spinner.active = false;
            spinner.halign = Gtk.Align.CENTER;
            spinner.vexpand = true;
            spinner.hexpand = true;

            grid.attach (widget_cpu, 0, 0, 1, 1);
            grid.attach (spinner, 1, 0, 1, 1);
            grid.attach (widget_memory, 2, 0, 1, 1);

            var content_box = get_content_area () as Gtk.Box;
            content_box.border_width = 0;
            content_box.add (grid);
            content_box.show_all ();

            //drag the window
            button_press_event.connect ((e) => {
                if (e.button == Gdk.BUTTON_PRIMARY) {
                    begin_move_drag ((int) e.button, (int) e.x_root, (int) e.y_root, e.time);
                    return true;
                }
                return false;
            });

            //Settings app
            var settings = AppSettings.get_default ();

            int x = settings.window_x;
            int y = settings.window_y;

            if (x != -1 && y != -1) {
                move (x, y);
            }

            Unix.signal_add (Posix.Signal.INT, signal_source_func, Priority.HIGH);
            Unix.signal_add (Posix.Signal.TERM, signal_source_func, Priority.HIGH);

            var provider = new Gtk.CssProvider ();
            provider.load_from_resource ("com/github/kmal-kenneth/monilet/css/style.css");
            Gtk.StyleContext.add_provider_for_screen (
                                Gdk.Screen.get_default (),
                                provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
        }

        //update the services
        private void update () {
            Timeout.add_seconds (1, () => {
                widget_cpu.progress = cpu.percentage_used;
                widget_memory.progress = memory.percentage_used;
                widget_memory.used = memory.used;
                widget_memory.total = memory.total;
               return true;
           });
        }

        //Save state of app
        private bool request_quit () {
            int x, y;
            get_position (out x, out y);

            var settings = AppSettings.get_default ();
            settings.window_x = x;
            settings.window_y = y;

            return false;
        }

        //delete the window
        public override bool delete_event (Gdk.EventAny event) {
            return request_quit ();
        }

        //Signal for close window
        private bool signal_source_func () {
            if (!request_quit ()) {
                destroy ();
            }

            return true;
        }
    }
}
