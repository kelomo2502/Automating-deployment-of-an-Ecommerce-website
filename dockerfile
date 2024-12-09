# Step 1: Use the official Nginx base image
FROM nginx:latest

# Step 2: Copy your application files to the Nginx default HTML directory
COPY ./dist /usr/share/nginx/html

# Step 3: Expose the port Nginx listens on (default is 80)
EXPOSE 80

# Step 4: Use the default Nginx startup command
CMD ["nginx", "-g", "daemon off;"]
