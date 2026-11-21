# ==============================================================================
# Dockerfile: Online Complaint and Helpdesk System (Java Swing + SQLite)
# ==============================================================================

# Use official lightweight Eclipse Temurin JDK 21
FROM eclipse-temurin:21-jdk

# Install X11, fonts, and graphical rendering libraries required for Java Swing
RUN apt-get update && apt-get install -y --no-install-recommends \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libxext6 \
    libfreetype6 \
    fontconfig \
    x11-apps \
    && rm -rf /var/lib/apt/lists/*

# Set working directory inside the container
WORKDIR /app

# Copy dependency libraries and source code
COPY lib/ ./lib/
COPY src/ ./src/
COPY schema.sql ./
COPY helpdesk.db ./

# Compile Java source code into bin directory
RUN mkdir -p bin && \
    javac -cp "lib/*:src" -d bin $(find src -name "*.java")

# Default DISPLAY variable (can be overridden at runtime)
ENV DISPLAY=:0

# Command to execute the Java application
ENTRYPOINT ["java", "--enable-native-access=ALL-UNNAMED", "-cp", "lib/*:bin", "com.helpdesk.Main"]
