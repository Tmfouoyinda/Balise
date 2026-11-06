import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    // Listen on all interfaces so Caddy can reach the container
    host: '0.0.0.0',
    port: 5173,
    strictPort: true,
    watch: {
      // Set in compose.yml: Windows bind mounts do not forward file events
      usePolling: process.env.VITE_USE_POLLING === 'true',
    },
  },
})
