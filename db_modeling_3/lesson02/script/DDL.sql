-- カラムを追加
ALTER TABLE documents
ADD COLUMN display_position DECIMAL(10, 4) AFTER user_id;


CREATE TABLE users (
    id VARCHAR(9) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE directories (
    id VARCHAR(9) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    user_id VARCHAR(9) NOT NULL,
    parent_directory_id VARCHAR(9),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE documents (
    id VARCHAR(9) PRIMARY KEY,
    directory_id VARCHAR(9) NOT NULL,
    name VARCHAR(255) NOT NULL,
    content TEXT,
    user_id VARCHAR(9) NOT NULL,
    display_position DECIMAL(10, 4),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (directory_id) REFERENCES directories(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE document_histories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    document_id VARCHAR(9) NOT NULL,
    user_id VARCHAR(9) NOT NULL,
    status VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (document_id) REFERENCES documents(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
