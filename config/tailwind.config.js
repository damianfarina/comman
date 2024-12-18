const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './config/initializers/ransack.rb',
  ],
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    require('@tailwindcss/aspect-ratio'),
  ],
  theme: {
    fontFamily: {
      sans: ['Inter var', ...defaultTheme.fontFamily.sans],
    },
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      'green': {
        100: '#9FE5BE',
        300: '#7FDCA9',
        500: '#60D394',
        700: '#3FCA7E',
        900: '#30B06A',
        DEFAULT: '#60D394',
      },
      'lightGreen': {
        100: '#DFF6E9',
        300: '#BFEDD4',
        500: '#9FE5BE',
        700: '#7FDCA9',
        900: '#5FD393',
        DEFAULT: '#9FE5BE',
      },
      'red': {
        100: '#F6A8A2',
        300: '#F2857D',
        500: '#EE6054',
        700: '#EB3F33',
        900: '#DF2316',
        DEFAULT: '#EE6054',
      },
      'lightRed': {
        100: '#FDDED6',
        300: '#FBBCAD',
        500: '#FF9B85',
        700: '#F97A5C',
        900: '#F95833',
        DEFAULT: '#FF9B85',
      },
      'yellow': {
        100: '#FBDA85',
        300: '#FBCE5C',
        500: '#FFC233',
        700: '#FAB608',
        900: '#E09D00',
        DEFAULT: '#FFC233',
      },
      'lightYellow': {
        100: '#FEF9EB',
        300: '#FDEDC2',
        500: '#FFE199',
        700: '#FBD470',
        900: '#FAC848',
        DEFAULT: '#FFE199',
      },
      'blue': {
        100: '#3C87CD',
        300: '#2E72B2',
        500: '#235789',
        700: '#1D4972',
        900: '#153451',
        DEFAULT: '#235789',
      },
      'lightBlue': {
        100: '#FFFFFF',
        300: '#EBF2FF',
        500: '#C9DDFF',
        700: '#ADCBFF',
        900: '#85B1FF',
        DEFAULT: '#C9DDFF',
      },
      'white': {
        100: '#FFFFFF',
        300: '#FDFDFD',
        500: '#FAFAFA',
        700: '#EBEBEB',
        900: '#D6D6D6',
        DEFAULT: '#FAFAFA',
      },
      'black': {
        100: '#4F4640',
        300: '#38322E',
        500: '#1c1917',
        700: '#161412',
        900: '#0B0A09',
        DEFAULT: '#1c1917',
      },
      'gray': {
        100: '#817A74',
        300: '#6B6761',
        500: '#57534e',
        700: '#403E3A',
        900: '#2B2A27',
        DEFAULT: '#57534e',
      },
      'lightGray': {
        100: '#F5F5F4',
        300: '#E2E0DF',
        500: '#d6d3d1',
        700: '#C5C1BE',
        900: '#B2ACA9',
        DEFAULT: '#d6d3d1',
      },
    },
  },
}
