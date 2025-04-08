# NimbusBox - Self-Hosted Dropbox Alternative

A self-hosted file storage and sharing solution with version control and secure sharing capabilities.

## Features

- File upload/download with drag-and-drop UI
- User authentication and folder management
- File versioning with rollback support
- Shareable links (with optional expiry/password)
- Optional: End-to-end encryption for files

## Prerequisites

- Node.js (v16 or later)
- Docker and Docker Compose
- Supabase account

## Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/nimbusbox.git
   cd nimbusbox
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up environment variables:
   Create a `.env` file in the root directory with the following content:
   ```
   VITE_SUPABASE_URL=your_supabase_url
   VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. Start the development environment:
   ```bash
   docker-compose up -d
   ```

5. Start the development server:
   ```bash
   npm run dev
   ```

## Development

The project uses the following technologies:

- Frontend: React with TypeScript, Material-UI
- Backend: Supabase (Auth, Database, Storage)
- Storage: MinIO (S3-compatible)
- Caching: Redis

### Project Structure

```
src/
  ├── components/     # Reusable UI components
  ├── pages/         # Page components
  ├── config/        # Configuration files
  ├── hooks/         # Custom React hooks
  ├── services/      # API services
  └── utils/         # Utility functions
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
