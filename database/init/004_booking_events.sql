INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    id,
    (
        ARRAY[
            'BOOKING_CREATED',
            'PAYMENT_SUCCESS',
            'CHECKIN',
            'CHECKOUT'
        ]
    )[floor(random()*4 + 1)],
    jsonb_build_object(
        'source','system',
        'status','success'
    ),
    created_at + interval '1 hour'
FROM hotel_bookings
LIMIT 75;
