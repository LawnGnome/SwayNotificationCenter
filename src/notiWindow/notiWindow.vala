namespace SwayNotificatonCenter {
    [GtkTemplate (ui = "/org/erikreider/sway-notification-center/notiWindow/notiWindow.ui")]
    public class NotiWindow : Gtk.ApplicationWindow {

        [GtkChild]
        unowned Gtk.Box box;

        public NotiWindow () {
            GtkLayerShell.init_for_window (this);
            GtkLayerShell.set_layer (this, GtkLayerShell.Layer.OVERLAY);
            GtkLayerShell.set_anchor (this, GtkLayerShell.Edge.TOP, true);
            GtkLayerShell.set_anchor (this, GtkLayerShell.Edge.RIGHT, true);
        }

        public void change_visibility (bool value) {
            this.set_visible (value);
            if (!value) close_all_notifications ();
        }

        public void close_all_notifications () {
            foreach (var w in box.get_children ()) {
                box.remove (w);
            }
        }

        private void removeWidget (Gtk.Widget widget) {
            uint len = box.get_children ().length () - 1;
            box.remove (widget);
            if (len <= 0) this.hide ();
        }

        public void add_notification (NotifyParams param, NotiDaemon notiDaemon) {
            var noti = new Notification (param, notiDaemon);
            box.pack_end (noti, false, false, 0);
            noti.show_notification ((v_noti) => {
                if (box.get_children ().index (v_noti) >= 0) {
                    box.remove (v_noti);
                }
                if (box.get_children ().length () == 0) this.hide ();
            });
            this.show ();
        }

        public void close_notification (uint32 id) {
            foreach (var w in box.get_children ()) {
                var noti = (Notification) w;
                if (noti != null && noti.param.applied_id == id) {
                    removeWidget (w);
                    break;
                }
            }
        }
    }
}
