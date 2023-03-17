# README

The organize_vocab REST API is made for language learners and will help them organize and manage their vocabulary words.

There are pre-existing words made available through the public `/words` endpoint.

Registered users can add these or newly created words to their personal vocabulary list. A user's words will also populate the list of public words though only they themselves will be able to look up which ones belong to their personal list.

Currently, Chinese is the only supported language.

## Using the API

All endpoints are documented and can be tried out using [Swagger UI](https://api.organize-vocab.com/api-docs/index.html).

The `/words` endpoint is public. The `/vocabulary_words` endpoint is protected with OAuth as it has a user's personal vocabulary words.

For testing purposes, you may use the user credentials listed below.
Alternatively, you can register as a new user using the test `client_id` and `client_secret` at the `/users` endpoint.

#### Example for logging in:

```json
{
  "grant_type": "password",
  "email": "test@user.com",
  "password": "password",
  "client_id": "test-id",
  "client_secret": "test-secret"
}
```
