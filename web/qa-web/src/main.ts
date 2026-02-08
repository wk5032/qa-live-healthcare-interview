import { createApp } from 'vue';
import Antd from 'ant-design-vue';
import 'ant-design-vue/dist/reset.css';
import './style.css';
import App from './App.vue';
import router from './router';
import { i18n } from './locales/i18n';

// Initialize i18n
i18n.init();

const app = createApp(App);

app.use(Antd);
app.use(router);
app.mount('#app');
