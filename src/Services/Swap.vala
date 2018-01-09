namespace monitor {
    public class Swap  : GLib.Object {
        private float _percentage_used;
        private float _total;
        private float _used;
        
        public float percentage_used {
            get { update_percentage_used (); return _percentage_used; }
        }
        public float total {
            get { update_total (); return _total; }
        }
        public float used {
            get { update_used (); return _used; }
        }

        public Swap (){
            this._percentage_used = 0;
            this._used = 0;
            this._total = 0;
        }
        
        private void update_percentage_used (){
            _percentage_used = ((used / total) * 100);
        }
        
        private void update_total (){
            GTop.Swap swap;
            GTop.get_swap (out swap);
            _total = (((float) swap.total / 1024) /1024) / 1024;
        }
        
        private void update_used (){
            GTop.Swap swap;
            GTop.get_swap (out swap);
            _used = (((float) swap.used / 1024) /1024) / 1024;
        }  
    }
}
