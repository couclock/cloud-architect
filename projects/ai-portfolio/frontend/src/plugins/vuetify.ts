import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
// plugins/vuetify.ts
import 'vuetify/styles'

export default createVuetify({
  components,
  directives,
  theme: { defaultTheme: 'system' },
  icons: {
    defaultSet: 'mdi',
    sets: {},
  },
})
