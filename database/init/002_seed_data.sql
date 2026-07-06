INSERT INTO hotel_bookings (
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)
SELECT
    gen_random_uuid(),
    'HTL-' || gs,
    (
        ARRAY[
            'delhi',
            'mumbai',
            'pune',
            'bangalore',
            'hyderabad'
        ]
    )[floor(random() * 5 + 1)],

    CURRENT_DATE + ((random() * 10)::int),

    CURRENT_DATE + ((random() * 15)::int) + 5,

    ROUND((random() * 8000 + 2000)::numeric, 2),

    (
        ARRAY[
            'CONFIRMED',
            'CANCELLED',
            'PENDING',
            'COMPLETED'
        ]
    )[floor(random() * 4 + 1)],

    NOW() - (((random() * 40)::int) || ' days')::interval

FROM generate_series(1,100) gs;
