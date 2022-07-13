FROM denoland/deno:1.23.3 as base
WORKDIR /app
COPY . ./
RUN deno cache server.ts
EXPOSE 8000
CMD ["deno", "run", "--allow-net", "server.ts"]