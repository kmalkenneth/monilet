/*
* Copyright (c) 2017-2017 kaml-kenneth (https://github.com/kmal-kenneth)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Kenet Mauricio Acuña Lago <kmal.kenneth@live.com>
*/

using Gtk;

namespace monilet {

    public class MainWindow : Gtk.Dialog {
        // application reference
        //private Application app;

        // Widgets
        //private Gtk.HeaderBar header;
        private WidgetCpu widget_cpu;
        private WidgetMemory widget_memory;
        private CPU cpu;
        private Memory memory;

        public MainWindow (Application app) {
            Object (application: app,
                    resizable: false,
                    title: _("Nimbus"),
                    height_request: 272,
                    width_request: 500);
            //this.app = app;
            //this.set_application (this.app);
            //this.set_default_size (880, 720);
            this.window_position = Gtk.WindowPosition.CENTER;
            //this.get_style_context ().add_class ("rounded");
            
            widget_cpu.cores = cpu.quantity_cores;
            update ();
            
            //progress_cpu.progress = 70;
        }
        
        construct {
            get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            
            cpu = new CPU ();
            memory = new Memory ();
            widget_cpu = new WidgetCpu ();
            widget_memory = new WidgetMemory ();
            //set_keep_below (true);
            //stick ();
            
            var grid = new Gtk.Grid ();
            grid.column_spacing = 12;
            grid.margin_bottom = 6;
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
        }
        
        private void update () {
    	    Timeout.add_seconds (1, () => {
    	        widget_cpu.progress = cpu.percentage_used;
    	        widget_memory.progress = memory.percentage_used;
    	        widget_memory.used = memory.used;
    	        widget_memory.total = memory.total;
               return true;
           });
    	}

    }
}

