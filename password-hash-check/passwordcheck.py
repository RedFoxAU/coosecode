import bcrypt

# Prompt the user for unhashed_password
unhashed_password = input("Enter your password: ")

# Users hash for unhashed_password
hashed_password = bcrypt.hashpw(unhashed_password.encode('utf-8'), bcrypt.gensalt())

# Display the hashed password
print(f"Hashed password: {hashed_password.decode('utf-8')}")

# Prompt the user to enter their hash
password_to_check = input("Re-enter your password to check if it matches the hash: ")

# Check if the entered password matches the hashed password
if bcrypt.checkpw(password_to_check.encode('utf-8'), hashed_password):
    print("The password matches!")
else:
    print("The password does not match.")
