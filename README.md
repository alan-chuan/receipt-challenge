# Fetch Receipt Web Service
This guide will help you set up the Fetch Receipt Web Service using Docker.

## Setting up the Web Service locally
### 1) Build the Docker image by running the following command:
```
docker build --tag receipt-webservice .
```

### 2) Run the Docker image
```
docker run -p 4567:4567 receipt-webservice
```

## API Endpoints
### Submitting a Receipt for Processing
**Endpoint:** POST `/receipts/process`

**Description:** This endpoint is used to submit a receipt for processing.
**Request Body Data Types:**
- `retailer (string)`: The name of the retailer or store the receipt is from. (Spaces are allowed in betweeen words, but not before or after.)
- `purchaseDate (string, date format)`: The date of the purchase printed on the receipt.
- `purchaseTime (string, time format)`: The time of the purchase printed on the receipt. 24-hour time format is expected.
- `items (array of objects)`:
  - `shortDescription (string)`: The short product description for the item.
  - `price (string, monetary format)`: The total price paid for this item.
- `total (string, monetary format)`: The total amount paid on the receipt.

**Example Request Body (JSON):**
```
{
    "retailer": "M&M Corner Market",
    "purchaseDate": "2022-01-01",
    "purchaseTime": "13:01",
    "items": [
        {
            "shortDescription": "Mountain Dew 12PK",
            "price": "6.49"
        }
    ],
    "total": "6.49"
}
```
**Responses:**
- `200 OK`: If the receipt is successfully processed, you will receive a response with a receipt ID.
```
{
    "id": "adb6b560-0eef-42bc-9d16-df48f30e89b2"
}
```
- `400 Bad Request`: If the request body is invalid, you may receive a 400 error. Troubleshoot by ensuring that the request body follows the expected JSON format and that all required fields (retailer, purchaseDate, purchaseTime, items, total) are provided with the correct data types.

- `422 Unprocessable Entity`: Indicates that the request was understood, but it couldn't be processed due to validation errors. The response will include additional details about the validation errors. To troubleshoot, review the error details in the response to identify and correct the specific issues in your request.


### Retrieving Points for a Receipt
**Endpoint:** GET `/receipts/{id}/points`

**Description:** This endpoint is used to retrieve the points awarded for a specific receipt based on its ID.

**URL Parameter:**
- `id`: The UUID of the receipt you want to retrieve points for.

**Example Request:** GET `/receipts/adb6b560-0eef-42bc-9d16-df48f30e89b2/points`

**Responses:** After submitting a receipt for processing, you can expect the following responses:

- `200 OK`: If the receipt is successfully processed, you will receive a response with a receipt ID.
```
{
    "points": 12
}
```
- `404 NOT FOUND`: If there was no receipt with that ID found in the system. To troubleshoot, ensure that the ticket ID is of valid UUID format and the receipt was created prior to the GET request.
  



