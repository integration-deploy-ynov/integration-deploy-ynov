const request = require('supertest');
const initApp = require('../app');

let app;

beforeAll(async () => {
  app = await initApp();
});

describe('Lamps Routes', () => {
  test('GET /api/lamps should return all lamps', async () => {
    const response = await request(app).get('/api/lamps');
    expect(response.status).toBe(200);
    expect(Array.isArray(response.body)).toBe(true);
  });
  
  test('PUT /api/lamps/:id should return 404 if lamp does not exist', async () => {
    const response = await request(app).put('/api/lamps/9999'); // ID peu probable
  
    expect(response.status).toBe(404);
    expect(response.body.error).toMatch(/non trouvée/i);
  });
});
