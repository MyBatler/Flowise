import { useState, useEffect } from 'react'
import LoginDialog from '@/ui-component/dialog/LoginDialog' // ודא שהנתיב נכון

import { useSelector } from 'react-redux'

import { ThemeProvider } from '@mui/material/styles'
import { CssBaseline, StyledEngineProvider } from '@mui/material'

// routing
import Routes from '@/routes'

// defaultTheme
import themes from '@/themes'

// project imports
import NavigationScroll from '@/layout/NavigationScroll'

// ==============================|| APP ||============================== //

const App = () => {
const [isAuthenticated, setIsAuthenticated] = useState(() => {
  return localStorage.getItem('loggedIn') === 'true'
})

    const customization = useSelector((state) => state.customization)

   return (
  <>
    {!isAuthenticated && (
      <LoginDialog
        show={true}
        dialogProps={{ title: 'Login', confirmButtonName: 'Login' }}
onConfirm={(username, password) => {
  console.log('USERNAME ENV:', import.meta.env.VITE_FLOWISE_USERNAME)
  console.log('PASSWORD ENV:', import.meta.env.VITE_FLOWISE_PASSWORD)
  console.log('USER INPUT:', username, password)

  if (
    username === import.meta.env.VITE_FLOWISE_USERNAME &&
    password === import.meta.env.VITE_FLOWISE_PASSWORD
  ) {
    localStorage.setItem('loggedIn', 'true')
    setIsAuthenticated(true)
  } else {
    alert('Wrong credentials')
  }
}}
      />
    )}

    {isAuthenticated && (
      <StyledEngineProvider injectFirst>
        <ThemeProvider theme={themes(customization)}>
          <CssBaseline />
          <NavigationScroll>
            <Routes />
          </NavigationScroll>
        </ThemeProvider>
      </StyledEngineProvider>
    )}
  </>
)

}

export default App
