const extend = {
  backgroundImage: {
    "monolith": "url('monolith.png')"
  },
  typography: (theme) => ({
    "off-white": {
      css: {
        '--tw-prose-body': theme('colors.off-white'),
        '--tw-prose-bold': theme('colors.off-white'),
        '--tw-prose-bullets': theme('colors.off-white'),
        '--tw-prose-captions': theme('colors.off-white'),
        '--tw-prose-code': theme('colors.off-white'),
        '--tw-prose-counters': theme('colors.off-white'),
        '--tw-prose-headings': theme('colors.off-white'),
        '--tw-prose-hr': theme('colors.off-white'),
        '--tw-prose-lead': theme('colors.off-white'),
        '--tw-prose-pre-bg': theme('colors.off-white'),
        '--tw-prose-pre-code': theme('colors.off-white'),
        '--tw-prose-quote-borders': theme('colors.off-white'),
        '--tw-prose-quotes': theme('colors.off-white'),
        '--tw-prose-td-borders': theme('colors.dark-gray'),
        '--tw-prose-th-borders': theme('colors.dark-gray'),
      }
    }
  }),
}

const theme = {
  colors: {
    'black': '#000000',
    'dark-gray': '#444444',
    'off-black': '#111111',
    'off-white': '#dddddd',
    'pink': '#ff01ff',
    'purple': '#800080',
    'white': '#ffffff',
  },
  fontFamily: {
    sans: ['verdana'],
  },
  extend,
}

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/assets/javascripts/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme,
  plugins: [
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/line-clamp'),
    require('@tailwindcss/typography'),
  ]
}
