/** @type {import('tailwindcss').Config} */

const colors = require('tailwindcss/colors')

module.exports = {
  content: [
    "output/**/*.html"
  ],
  darkMode: 'class', // remove once dark mode styles are better
  theme: {
    extend: {
      colors: {
        brand: "#800080",
        primary: colors.purple,
        secondary: colors.emerald,
        neutral: colors.gray
      }
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}
