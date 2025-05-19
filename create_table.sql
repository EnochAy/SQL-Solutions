-- Table: plans_plan
CREATE TABLE plans_plan (
    id CHAR(32) NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255) NOT NULL,
    amount INTEGER NOT NULL,
    start_date DATE,
    last_charge_date DATE,
    next_charge_date DATE,
    created_on TIMESTAMP NOT NULL,
    frequency_id INTEGER NOT NULL,
    owner_id CHAR(32) NOT NULL,
    status_id INTEGER NOT NULL,
    interest_rate DOUBLE PRECISION NOT NULL,
    withdrawal_date DATE,
    default_plan BOOLEAN NOT NULL,
    plan_type_id INTEGER NOT NULL,
    goal DOUBLE PRECISION NOT NULL,
    locked BOOLEAN NOT NULL,
    next_returns_date DATE NOT NULL,
    last_returns_date DATE NOT NULL,
    cowry_amount INTEGER NOT NULL,
    PRIMARY KEY (id)
);

-- Table: savings_savingsaccount
CREATE TABLE savings_savingsaccount (
    id SERIAL PRIMARY KEY,
    savings_id CHAR(32),
    maturity_start_date TIMESTAMP NOT NULL,
    maturity_end_date TIMESTAMP NOT NULL,
    amount DOUBLE PRECISION NOT NULL,
    confirmed_amount DOUBLE PRECISION NOT NULL,
    deduction_amount DOUBLE PRECISION NOT NULL,
    new_balance DOUBLE PRECISION NOT NULL,
    transaction_date TIMESTAMP NOT NULL,
    transaction_reference VARCHAR(200) NOT NULL,
    transaction_status VARCHAR(200) NOT NULL,
    verification_call_amount VARCHAR(200) NOT NULL,
    verification_call_message VARCHAR(100) NOT NULL,
    verification_call_code VARCHAR(50) NOT NULL,
    verification_transaction_date TIMESTAMP,
    book_returns DOUBLE PRECISION NOT NULL,
    available_returns DOUBLE PRECISION NOT NULL,
    returns_on_hold DOUBLE PRECISION NOT NULL,
    last_returns_date DATE NOT NULL,
    next_returns_date DATE NOT NULL
);

-- Table: users_customuser
CREATE TABLE users_customuser (
    id CHAR(32) NOT NULL,
    password VARCHAR(128) NOT NULL,
    last_login TIMESTAMP,
    is_superuser BOOLEAN NOT NULL,
    email VARCHAR(60) NOT NULL,
    name VARCHAR(100),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone_number VARCHAR(128),
    date_of_birth DATE,
    is_staff BOOLEAN NOT NULL,
    is_active BOOLEAN NOT NULL,
    date_joined TIMESTAMP NOT NULL,
    is_admin BOOLEAN NOT NULL,
    username VARCHAR(25),
    created_on TIMESTAMP NOT NULL,
    gender_id INTEGER,
    invite_code VARCHAR(100),
    avatar_firebase_reference VARCHAR(255),
    avatar_local_uri VARCHAR(255),
    PRIMARY KEY (id),
    UNIQUE (email)
);

-- Table: withdrawals_withdrawal
CREATE TABLE withdrawals_withdrawal (
    id SERIAL PRIMARY KEY,
    amount DOUBLE PRECISION NOT NULL,
    amount_withdrawn DOUBLE PRECISION NOT NULL,
    transaction_reference VARCHAR(50) NOT NULL,
    transaction_date TIMESTAMP NOT NULL,
    new_balance DOUBLE PRECISION NOT NULL,
    bank_id INTEGER,
    owner_id CHAR(32) NOT NULL,
    plan_id CHAR(32) NOT NULL,
    transaction_channel_id INTEGER NOT NULL,
    transaction_status_id INTEGER NOT NULL,
    transaction_type_id INTEGER NOT NULL,
    fee_in_kobo DOUBLE PRECISION NOT NULL,
    description VARCHAR(255) NOT NULL,
    gateway VARCHAR(255),
    gateway_response VARCHAR(255),
    session_id VARCHAR(50),
    currency CHAR(3) NOT NULL,
    fee_in_cents DOUBLE PRECISION NOT NULL,
    payment_id VARCHAR(50)
);


ALTER TABLE plans_plan
ADD CONSTRAINT fk_owner_id
FOREIGN KEY (owner_id) REFERENCES users_customuser(id);

ALTER TABLE savings_savingsaccount
ADD CONSTRAINT fk_savings_id
FOREIGN KEY (savings_id) REFERENCES plans_plan(id);

ALTER TABLE withdrawals_withdrawal
ADD CONSTRAINT fk_owner_id
FOREIGN KEY (owner_id) REFERENCES users_customuser(id);

ALTER TABLE withdrawals_withdrawal
ADD CONSTRAINT fk_plan_id
FOREIGN KEY (plan_id) REFERENCES plans_plan(id);

SELECT COUNT(*) FROM plans_plan;
SELECT COUNT(*) FROM savings_savingsaccount;
SELECT COUNT(*) FROM users_customuser;
SELECT COUNT(*) FROM withdrawals_withdrawal;

