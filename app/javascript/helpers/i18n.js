import i18n from 'i18next'
import { initReactI18next } from 'react-i18next'

const resources = {
  ru: {
    translation: require('react-trello/src/locales/ru/translation.json'),
  },
  en: {
    translation: require('react-trello/src/locales/en/translation.json'),
  },
}

i18n
  .use(initReactI18next) // passes i18n down to react-i18next
  .init({
    resources,
    lng: document.documentElement.getAttribute('lang') || 'en',
    debug: true,
    react: {
      useSuspense: false,
    },
  })

export default i18n
