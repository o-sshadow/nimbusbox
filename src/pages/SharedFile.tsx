import { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import {
  Container,
  Box,
  Typography,
  Button,
  CircularProgress,
  Paper,
  TextField,
  Alert,
} from '@mui/material';
import { supabase } from '../config/supabase';

interface SharedFileData {
  id: string;
  file_id: string;
  token: string;
  password_hash: string | null;
  expires_at: string | null;
  created_at: string;
}

const SharedFile = () => {
  const { token } = useParams<{ token: string }>();
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [sharedFile, setSharedFile] = useState<SharedFileData | null>(null);
  const [password, setPassword] = useState('');
  const [fileUrl, setFileUrl] = useState<string | null>(null);

  useEffect(() => {
    const fetchSharedFile = async () => {
      try {
        const { data, error } = await supabase
          .from('shares')
          .select('*')
          .eq('token', token)
          .single();

        if (error) throw error;

        if (!data) {
          setError('Shared file not found');
          return;
        }

        if (data.expires_at && new Date(data.expires_at) < new Date()) {
          setError('This shared file has expired');
          return;
        }

        setSharedFile(data);
      } catch (error) {
        setError('Error fetching shared file');
        console.error(error);
      } finally {
        setLoading(false);
      }
    };

    fetchSharedFile();
  }, [token]);

  const handlePasswordSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      // In a real application, you would verify the password hash here
      const { data, error } = await supabase.storage
        .from('files')
        .createSignedUrl(sharedFile?.file_id || '', 3600); // 1 hour expiry

      if (error) throw error;

      setFileUrl(data.signedUrl);
    } catch (error) {
      setError('Error accessing file');
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <Container maxWidth="sm">
        <Box sx={{ display: 'flex', justifyContent: 'center', my: 4 }}>
          <CircularProgress />
        </Box>
      </Container>
    );
  }

  if (error) {
    return (
      <Container maxWidth="sm">
        <Box sx={{ my: 4 }}>
          <Alert severity="error">{error}</Alert>
        </Box>
      </Container>
    );
  }

  if (sharedFile?.password_hash && !fileUrl) {
    return (
      <Container maxWidth="sm">
        <Box sx={{ my: 4 }}>
          <Paper sx={{ p: 3 }}>
            <Typography variant="h6" gutterBottom>
              Password Required
            </Typography>
            <form onSubmit={handlePasswordSubmit}>
              <TextField
                fullWidth
                label="Password"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                margin="normal"
                required
              />
              <Button
                type="submit"
                variant="contained"
                fullWidth
                sx={{ mt: 2 }}
                disabled={loading}
              >
                {loading ? 'Verifying...' : 'Access File'}
              </Button>
            </form>
          </Paper>
        </Box>
      </Container>
    );
  }

  if (fileUrl) {
    return (
      <Container maxWidth="lg">
        <Box sx={{ my: 4 }}>
          <Typography variant="h4" component="h1" gutterBottom>
            Shared File
          </Typography>
          <Paper sx={{ p: 3 }}>
            <Typography variant="body1" paragraph>
              File is ready to download. The link will expire in 1 hour.
            </Typography>
            <Button
              variant="contained"
              href={fileUrl}
              download
              target="_blank"
              rel="noopener noreferrer"
            >
              Download File
            </Button>
          </Paper>
        </Box>
      </Container>
    );
  }

  return null;
};

export default SharedFile; 