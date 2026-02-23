#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

cat << 'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Architecture Live</title>
    <style>
        body {
            background-color: #121212;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            font-family: 'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif;
        }
        h1 {
            font-size: 3rem;
            background: linear-gradient(to right, #00f2fe, #4facfe, #f093fb, #f5576c);
            -webkit-background-clip: text;
            color: transparent;
            text-align: center;
            padding: 20px;
        }
    </style>
</head>
<body>
    <h1>Olabanji, your enterprise 3-tier architecture is live ...</h1>
</body>
</html>
EOF