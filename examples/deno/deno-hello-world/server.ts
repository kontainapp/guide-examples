// https://deno.land/std@0.148.0/http/server.ts?s=serve
import { serve } from "https://deno.land/std/http/server.ts";

serve(req => new Response("Hello world from Deno!"));

console.log(`HTTP server is running at: http://localhost:8000/`);
