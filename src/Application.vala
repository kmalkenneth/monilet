/*  
*   Copyright (c) 2017-2019 kmal-kenneth (https://github.com/kmal-kenneth)
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

namespace monilet {

    public class Monilet : Gtk.Application {

        // Main Window
        private MainWindow? app_window = null;

        //Constructor
        public Monilet () {
            //Base
            Object (application_id: "com.github.kmal-kenneth.monilet",
            flags: ApplicationFlags.FLAGS_NONE);
        }
        
        //Active App
        protected override void activate () {
            if (get_windows ().length () > 0) {
                get_windows ().data.present ();
                return;
            }
            
            app_window = new MainWindow (this);
            app_window.show ();

            //key action
            var quit_action = new SimpleAction ("quit", null);
    
            add_action (quit_action);
            set_accels_for_action ("app.quit", {"<Control>q"});
    
            quit_action.activate.connect (() => {
                if (app_window != null) {
                    app_window.close ();
                }
            });
        }
    
        //Main
        public static int main (string[] args) {
            var app = new Monilet ();
            return app.run (args);
        }
    }
}
