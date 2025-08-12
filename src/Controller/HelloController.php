<?php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class HelloController extends AbstractController
{
    #[Route('/', name: 'app_hello')]
    public function index(): Response
    {
        return new Response('<h1>Hello from test 407!</h1>');
    }
}
