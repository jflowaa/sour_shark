/** @type {import('tailwindcss').Config} */

const colors = require("tailwindcss/colors");

module.exports = {
  content: ["output/**/*.html"],
  darkMode: "media",
  theme: {
    extend: {
      colors: {
        brand: "#a259ec",
        primary: colors.indigo,
        secondary: colors.sky,
        neutral: colors.gray,
      },
    },
  },
  plugins: [require("@tailwindcss/typography")],
};
