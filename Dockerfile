# Use lightweight nginx image
FROM nginx:alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy your static site files (build output) into nginx
COPY . /usr/share/nginx/html

# Expose port (App Platform uses 8080 internally but nginx runs on 80)
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
