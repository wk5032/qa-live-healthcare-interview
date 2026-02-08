import { ref, computed } from 'vue';
import zhCN from './zh-CN.json';
import enUS from './en-US.json';

type Language = 'zh-CN' | 'en-US';

const messages: Record<Language, any> = {
  'zh-CN': zhCN,
  'en-US': enUS
};

const currentLanguage = ref<Language>('zh-CN');

export const i18n = {
  currentLanguage,
  messages,

  setLanguage(lang: Language) {
    currentLanguage.value = lang;
    localStorage.setItem('language', lang);
  },

  t(key: string): string {
    const keys = key.split('.');
    let value: any = messages[currentLanguage.value];

    for (const k of keys) {
      if (value && typeof value === 'object') {
        value = value[k];
      } else {
        return key;
      }
    }

    return typeof value === 'string' ? value : key;
  },

  init() {
    const savedLang = localStorage.getItem('language');
    if (savedLang && (savedLang === 'zh-CN' || savedLang === 'en-US')) {
      currentLanguage.value = savedLang as Language;
    }
  }
};

export const useI18n = () => {
  return {
    t: i18n.t,
    currentLanguage: i18n.currentLanguage,
    setLanguage: i18n.setLanguage
  };
};
