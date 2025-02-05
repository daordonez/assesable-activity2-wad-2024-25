import React, { useState } from "react";

function App() {
  // Estados para manejar la lógica del juego
  const [secretNumber, setSecretNumber] = useState(generateRandomNumber());
  const [guess, setGuess] = useState("");
  const [message, setMessage] = useState("");
  const [attempts, setAttempts] = useState(0);

  // Función para generar un número aleatorio entre 1 y 100
  function generateRandomNumber() {
    return Math.floor(Math.random() * 100) + 1;
  }

  // Manejar cambios en el input
  const handleInputChange = (event) => {
    setGuess(event.target.value); // Actualizar el valor de la suposición
  };

  // Comprobar si el número es correcto, mayor o menor
  const checkGuess = () => {
    const numericGuess = parseInt(guess, 10); // Convertir la entrada a número

    // Validar que el usuario haya ingresado un número válido
    if (isNaN(numericGuess)) {
      setMessage("Por favor, introduce un número válido.");
      return;
    }

    // Incrementar los intentos
    setAttempts(attempts + 1);

    // Comparar la suposición con el número secreto
    if (numericGuess === secretNumber) {
      setMessage(`¡Correcto! El número era ${secretNumber}. Lo lograste en ${attempts + 1} intentos.`);
    } else if (numericGuess < secretNumber) {
      setMessage("El número secreto es mayor.");
    } else {
      setMessage("El número secreto es menor.");
    }
  };

  // Reiniciar el juego
  const resetGame = () => {
    setSecretNumber(generateRandomNumber()); // Generar un nuevo número secreto
    setGuess(""); // Limpiar el input
    setMessage(""); // Limpiar el mensaje
    setAttempts(0); // Reiniciar el contador de intentos
  };

  // Renderizar la interfaz del juego
  return (
    <div style={styles.container}>
      <h1 style={styles.title}>Adivina el Número</h1>
      <p style={styles.instructions}>Introduce un número entre 1 y 100:</p>
      <input
        type="text"
        value={guess}
        onChange={handleInputChange}
        style={styles.input}
        placeholder="Tu suposición"
      />
      <div style={styles.buttonContainer}>
        <button onClick={checkGuess} style={styles.button}>
          Comprobar
        </button>
        <button onClick={resetGame} style={styles.button}>
          Reiniciar
        </button>
      </div>
      <p style={styles.message}>{message}</p>
      {attempts > 0 && <p style={styles.attempts}>Intentos: {attempts}</p>}
    </div>
  );
}

// Estilos en línea para la aplicación
const styles = {
  container: {
    textAlign: "center",
    marginTop: "50px",
  },
  title: {
    fontSize: "2rem",
    marginBottom: "20px",
  },
  instructions: {
    fontSize: "1rem",
    marginBottom: "10px",
  },
  input: {
    padding: "10px",
    fontSize: "1rem",
    marginBottom: "10px",
    width: "200px",
  },
  buttonContainer: {
    display: "flex",
    justifyContent: "center",
    gap: "10px",
    marginTop: "10px",
  },
  button: {
    padding: "10px 20px",
    fontSize: "1rem",
    cursor: "pointer",
  },
  message: {
    fontSize: "1.2rem",
    marginTop: "20px",
    color: "#333",
  },
  attempts: {
    fontSize: "1rem",
    marginTop: "10px",
    color: "#555",
  },
};

export default App;
