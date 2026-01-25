# ---------- Build stage ----------
FROM node:20.20.0-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build


# ---------- Production stage ----------
FROM nginx:alpine

# Create non-root user
RUN adduser -D appuser

# Give permissions to nginx required paths
RUN chown -R appuser:appuser /var/cache/nginx \
    && chown -R appuser:appuser /var/run \
    && chown -R appuser:appuser /run \
    && chown -R appuser:appuser /etc/nginx \
    && chown -R appuser:appuser /usr/share/nginx/html

COPY --from=builder /app/dist /usr/share/nginx/html

USER appuser

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

