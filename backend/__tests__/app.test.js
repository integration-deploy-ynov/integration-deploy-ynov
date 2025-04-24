const request = require('supertest');
const initApp = require('../app');
const rateLimit = require('express-rate-limit');

describe('App Setup', () => {
  let app;

  beforeAll(async () => {
    app = await initApp();
  });

  afterAll(async () => {
    // Close the database connection after all tests
    const db = require('../app/models');
    await db.sequelize.close();
  });

  test('should use express.json middleware', async () => {
    const response = await request(app)
      .post('/api/test')
      .send({ key: 'value' })
      .set('Content-Type', 'application/json');
    expect(response.status).toBe(404); // Assuming there's no route for /api/test
    expect(response.body).toEqual({}); // Expecting an empty body as there's no route
  });

  test('should use rateLimit middleware', async () => {
    for (let i = 0; i < 101; i++) {
      await request(app).get('/api/lamps');
    }
    const response = await request(app).get('/api/lamps');
    expect(response.status).toBe(429); // Too Many Requests
  });
});