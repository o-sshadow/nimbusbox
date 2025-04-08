import { useState, useCallback } from 'react';
import { useDropzone } from 'react-dropzone';
import {
  Container,
  Box,
  Typography,
  List,
  ListItem,
  ListItemText,
  ListItemIcon,
  IconButton,
  Paper,
  CircularProgress,
} from '@mui/material';
import {
  Folder as FolderIcon,
  InsertDriveFile as FileIcon,
  MoreVert as MoreVertIcon,
} from '@mui/icons-material';
import { supabase } from '../config/supabase';

interface FileItem {
  id: string;
  name: string;
  type: 'file' | 'folder';
  path: string;
  size?: number;
  created_at: string;
}

const FileBrowser = () => {
  const [files, setFiles] = useState<FileItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [currentPath] = useState<string[]>([]);

  const onDrop = useCallback(async (acceptedFiles: File[]) => {
    setLoading(true);
    try {
      for (const file of acceptedFiles) {
        const filePath = [...currentPath, file.name].join('/');
        const { data, error } = await supabase.storage
          .from('files')
          .upload(filePath, file);

        if (error) throw error;

        setFiles((prev) => [
          ...prev,
          {
            id: data.path,
            name: file.name,
            type: 'file',
            path: filePath,
            size: file.size,
            created_at: new Date().toISOString(),
          },
        ]);
      }
    } catch (error) {
      console.error('Error uploading files:', error);
    } finally {
      setLoading(false);
    }
  }, [currentPath]);

  const { getRootProps, getInputProps, isDragActive } = useDropzone({ onDrop });

  return (
    <Container maxWidth="lg">
      <Box sx={{ my: 4 }}>
        <Typography variant="h4" component="h1" gutterBottom>
          File Browser
        </Typography>

        <Paper
          {...getRootProps()}
          sx={{
            p: 3,
            mb: 3,
            border: '2px dashed #ccc',
            backgroundColor: isDragActive ? '#f5f5f5' : 'white',
            cursor: 'pointer',
          }}
        >
          <input {...getInputProps()} />
          <Typography align="center">
            {isDragActive
              ? 'Drop the files here...'
              : 'Drag and drop files here, or click to select files'}
          </Typography>
        </Paper>

        {loading && (
          <Box sx={{ display: 'flex', justifyContent: 'center', my: 2 }}>
            <CircularProgress />
          </Box>
        )}

        <List>
          {files.map((file) => (
            <ListItem
              key={file.id}
              secondaryAction={
                <IconButton edge="end" aria-label="more">
                  <MoreVertIcon />
                </IconButton>
              }
            >
              <ListItemIcon>
                {file.type === 'folder' ? <FolderIcon /> : <FileIcon />}
              </ListItemIcon>
              <ListItemText
                primary={file.name}
                secondary={`${file.size ? `${file.size} bytes` : ''} - ${
                  new Date(file.created_at).toLocaleDateString()
                }`}
              />
            </ListItem>
          ))}
        </List>
      </Box>
    </Container>
  );
};

export default FileBrowser; 