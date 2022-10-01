import { createApp } from "vue";
import App from "./App.vue";
import {
  Button,
  Field,
  Form,
  NoticeBar,
  Cell,
  CellGroup,
  List,
  Overlay,
  Divider,
} from "vant";
import "vant/lib/index.css";

const app = createApp(App);
app.use(Button);
app.use(Field);
app.use(Cell);
app.use(CellGroup);
app.use(Form);
app.use(Overlay);
app.use(List);
app.use(NoticeBar);
app.use(Divider);
app.mount("#app");
