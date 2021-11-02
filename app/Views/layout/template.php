<!doctype html>
<html lang="en">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">

    <script src="https://use.fontawesome.com/releases/v5.15.1/js/all.js" crossorigin="anonymous"></script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300&display=swap" rel="stylesheet">

    <title><?= $title; ?></title>

    <!-- My CSS -->
    <link rel="stylesheet" href="/assets/css/style.css">
</head>

<body>
    <div class="wrapper">
        <!-- Sidebar Start -->
        <div class="navigation">
            <ul>
                <li class="item brand">
                    <a href="/dashboard" class="text-decoration-none">
                        <span class="icon"><i class="fab fa-apple text-white"></i></span>
                        <span class="title">
                            <h2 class="text-white">Invent 01</h2>
                        </span>
                    </a>
                </li>
                <li class="item dashboard">
                    <a href="/dashboard" class="text-decoration-none">
                        <span class="icon"><i class="fas fa-desktop"></i></span>
                        <span class="title">
                            Dashboard
                        </span>
                    </a>
                </li>
                <?php if (session()->level === "U01" || session()->level === "U02") : ?>
                <li class="item log">
                    <a href="/dashboard/act-log" class="text-decoration-none">
                        <span class="icon"><i class="fas fa-cogs"></i></span>
                        <span class="title">
                            Log
                        </span>
                    </a>
                </li>
                <?php endif; ?>
                <?php if (session()->level === "U03") : ?>
                <li class="item invent">
                    <a href="/dashboard/my-invent" class="text-decoration-none">
                        <span class="icon"><i class="fas fa-inbox"></i></span>
                        <span class="title">
                            My Inventory
                        </span>
                    </a>
                </li>
                <?php endif; ?>
                <?php if (session()->level === "U01") : ?>
                <li class="item users" onclick="dropdownUsers();">
                    <a href="#" class="text-decoration-none menu-btn" id="item" data-bs-toggle="dropdown" role="button"
                        aria-expanded="false">
                        <span class="icon active"><i class="fas fa-users"></i></span>
                        <span class="title active">
                            Users
                        </span>
                    </a>
                    <div class="sub-menu">
                        <a href="/dashboard/users" class="text-decoration-none dropdown-item">
                            <span class="icon"><i class="fas fa-list"></i></span>
                            <span class="title">
                                List Users
                            </span>
                        </a>
                        <a href="/dashboard/users/create" class="text-decoration-none dropdown-item">
                            <span class="icon"><i class="fas fa-user-plus"></i></span>
                            <span class="title">
                                Add Users
                            </span>
                        </a>
                    </div>
                </li>
                <li class="item stuffs" onclick="dropdownItems();">
                    <a href="#" class="text-decoration-none menu-btn" id="item" data-bs-toggle="dropdown" role="button"
                        aria-expanded="false">
                        <span class="icon active"><i class="fas fa-boxes"></i></span>
                        <span class="title active">
                            Stuffs
                        </span>
                    </a>
                    <div class="sub-menu">
                        <a href="/dashboard/stuffs" class="text-decoration-none dropdown-item">
                            <span class="icon"><i class="fas fa-list"></i></span>
                            <span class="title">
                                List Stuffs
                            </span>
                        </a>
                        <a href="/dashboard/stuffs/create" class="text-decoration-none dropdown-item">
                            <span class="icon"><i class="fas fa-box-open"></i></span>
                            <span class="title">
                                Add Stuffs
                            </span>
                        </a>
                        <a href="/dashboard/stuffs/create" class="text-decoration-none dropdown-item">
                            <span class="icon"><i class="fas fa-box-open"></i></span>
                            <span class="title">
                                Add Stock
                            </span>
                        </a>
                    </div>
                </li>
                <?php endif; ?>
            </ul>
        </div>
        <!-- End Sidebar -->

        <!-- Main Header Start -->
        <div class="main">
            <div class="topbar shadow">
                <div class="toggle text-center" onclick="toggleMenu();">
                    <i class="fas fa-bars bars"></i>
                </div>
                <div class="user me-5">
                    <div class="dropdown">
                        <span class="dropdown-toggle text-white" id="dropdownMenuButton1" data-bs-toggle="dropdown"
                            aria-expanded="false">
                            <?= session()->nama; ?>
                        </span>
                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                            <li><a class="dropdown-item" href="#"><i class="fas fa-user-circle me-3"></i> My Profile</a>
                            </li>
                            <?php if (session()->level === "U03") : ?>
                            <li><a class="dropdown-item" href="/my-invent"><i class="fas fa-inbox me-3"></i> My
                                    Invent</a></li>
                            <?php endif; ?>
                            <li>
                                <hr class="dropdown-divider">
                            </li>
                            <li><a class="dropdown-item" href="/logout"><i class="fas fa-power-off me-3"></i> Logout</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <!-- End Main Header -->

        <!-- Content Start -->
        <div class="content">
            <?= $this->renderSection('content'); ?>
        </div>
        <!-- End Content -->

        <!-- Optional JavaScript; choose one of the two! -->

        <!-- Option 1: Bootstrap Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous">
        </script>

        <!-- Option 2: Separate Popper and Bootstrap JS -->
        <!--
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js" integrity="sha384-7+zCNj/IqJ95wo16oMtfsKbZ9ccEh31eOz1HGyDuCQ6wgnyJNSYdrPa03rtR1zdB" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js" integrity="sha384-QJHtvGhmr9XOIpI6YVutG+2QOK9T+ZnN4kzFN1RtK3zEFEIsxhlmWl5/YESvpZ13" crossorigin="anonymous"></script>
    -->

        <script>
        function toggleMenu() {
            let toggle = document.querySelector('.toggle');
            let navigation = document.querySelector('.navigation');
            let main = document.querySelector('.main');
            let content = document.querySelector('.content');

            toggle.classList.toggle('active');
            navigation.classList.toggle('active');
            main.classList.toggle('active');
            content.classList.toggle('active');
        }

        function dropdownUsers() {
            let users = document.querySelector('.users');

            users.classList.toggle('active');
        }

        function dropdownItems() {
            let items = document.querySelector('.stuffs');

            items.classList.toggle('active');
        }

        function dropdownProfile() {
            let profile = document.querySelector('.profile');

            profile.classList.toggle('active');
        }
        </script>
</body>

</html>