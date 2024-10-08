const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    require('@tailwindcss/aspect-ratio'),
  ],
  theme: {
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      'green': '#60D394',
      'lightGreen': '#9FE5BE',
      'red': '#EE6054',
      'lightRed': '#FF9B85',
      'yellow': '#FFC233',
      'lightYellow': '#FFE199',
      'blue': '#235789',
      'lightBlue': '#C9DDFF',
      'white': '#FAFAFA',
      'black': '#1c1917',
      'gray': '#57534e',
      'lightGray': '#d6d3d1',
    },
  },
}
