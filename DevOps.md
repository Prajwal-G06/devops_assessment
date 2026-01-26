## Troubleshooting and Challenges Faced

### Frontend Not Connecting to Backend (localhost Issue)

**Problem:**  
The frontend could not reach the backend API when both were running in Docker containers because `localhost` was used.

In Docker:
- `localhost` inside a container refers to **that same container**, not another container.
- So frontend → `localhost:8000` was trying to call itself, not the backend.

**Fix Implemented:**  
Instead of using `localhost` or hard-coding a Docker service name, the backend URL was dynamically built using the browser’s address.

```js
const API_URL = `${window.location.protocol}//${window.location.hostname}:8000/api/hello/`;
