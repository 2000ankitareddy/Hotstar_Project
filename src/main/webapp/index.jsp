<!DOCTYPE html>
<html>
<head>
    <title>Hotstar</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #141e30, #243b55);
            color: white;
        }

        header {
            background-color: #0f2027;
            padding: 20px;
            text-align: center;
            font-size: 28px;
            font-weight: bold;
            letter-spacing: 2px;
        }

        nav {
            text-align: center;
            padding: 15px;
            background-color: #203a43;
        }

        nav button {
            padding: 10px 25px;
            margin: 10px;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            cursor: pointer;
            background-color: #ff4b2b;
            color: white;
            transition: 0.3s;
        }

        nav button:hover {
            background-color: #ff416c;
            transform: scale(1.1);
        }

        .section {
            display: none;
            padding: 30px;
            text-align: center;
        }

        .card-container {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .card {
            background: white;
            color: black;
            width: 200px;
            border-radius: 15px;
            padding: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.5);
            transition: 0.3s;
        }

        .card:hover {
            transform: translateY(-10px);
        }

        .back-btn {
            margin-top: 30px;
            padding: 10px 20px;
            border: none;
            border-radius: 20px;
            background-color: #00c6ff;
            color: white;
            cursor: pointer;
        }

    </style>

    <script>
        function showSection(sectionId) {
            document.getElementById("home").style.display = "none";
            document.getElementById("movies").style.display = "none";
            document.getElementById("sports").style.display = "none";
            document.getElementById("tv").style.display = "none";

            document.getElementById(sectionId).style.display = "block";
        }
    </script>
</head>

<body>

<header>Hotstar</header>

<nav>
    <button onclick="showSection('movies')">Movies</button>
    <button onclick="showSection('sports')">Sports</button>
    <button onclick="showSection('tv')">TV Shows</button>
</nav>

<!-- HOME -->
<div id="home" class="section" style="display:block;">
    <h2>Welcome to Hotstar Clone</h2>
    <p>Watch Unlimited Movies, Sports & TV Shows</p>
</div>

<!-- MOVIES -->
<div id="movies" class="section">
    <h2>Trending Movies</h2>
    <div class="card-container">
        <div class="card">Avengers</div>
        <div class="card">RRR</div>
        <div class="card">Bahubali</div>
        <div class="card">Jawan</div>
    </div>
    <button class="back-btn" onclick="showSection('home')">Back</button>
</div>

<!-- SPORTS -->
<div id="sports" class="section">
    <h2> Live Sports</h2>
    <div class="card-container">
        <div class="card">IPL</div>
        <div class="card">Football</div>
        <div class="card">World Cup</div>
        <div class="card">Tennis</div>
    </div>
    <button class="back-btn" onclick="showSection('home')">Back</button>
</div>

<!-- TV SHOWS -->
<div id="tv" class="section">
    <h2>Popular TV Shows</h2>
    <div class="card-container">
        <div class="card">Stranger Things</div>
        <div class="card">Money Heist</div>
        <div class="card">Breaking Bad</div>
        <div class="card">The Boys</div>
    </div>
    <button class="back-btn" onclick="showSection('home')">Back</button>
</div>

</body>
</html>

