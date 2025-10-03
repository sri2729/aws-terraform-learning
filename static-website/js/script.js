// AWS Terraform Learning - Static Website JavaScript

// Smooth scrolling for navigation links
document.addEventListener('DOMContentLoaded', function() {
    const navLinks = document.querySelectorAll('.nav-menu a[href^="#"]');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            
            if (targetSection) {
                targetSection.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
});

// Infrastructure info modal
function showInfrastructureInfo() {
    const overlay = document.createElement('div');
    overlay.className = 'overlay';
    overlay.style.display = 'block';
    
    const modal = document.createElement('div');
    modal.className = 'infrastructure-info';
    modal.style.display = 'block';
    modal.innerHTML = `
        <h3>🚀 AWS Infrastructure Components</h3>
        <p><strong>VPC:</strong> Virtual Private Cloud with public/private subnets, Internet Gateway, and NAT Gateway</p>
        <p><strong>S3:</strong> Static website hosting with versioning, encryption, and CORS configuration</p>
        <p><strong>CloudFront:</strong> Global CDN with SSL termination and caching strategies</p>
        <p><strong>DynamoDB:</strong> NoSQL database for website data and user sessions</p>
        <p><strong>WAF:</strong> Web Application Firewall with rate limiting and security rules</p>
        <p><strong>Terraform:</strong> Infrastructure as Code for reproducible deployments</p>
        <button class="close-button" onclick="closeInfrastructureInfo()">Close</button>
    `;
    
    document.body.appendChild(overlay);
    document.body.appendChild(modal);
    
    // Close on overlay click
    overlay.addEventListener('click', closeInfrastructureInfo);
}

function closeInfrastructureInfo() {
    const overlay = document.querySelector('.overlay');
    const modal = document.querySelector('.infrastructure-info');
    
    if (overlay) overlay.remove();
    if (modal) modal.remove();
}

// Add some interactive features
document.addEventListener('DOMContentLoaded', function() {
    // Add hover effects to feature cards
    const featureCards = document.querySelectorAll('.feature-card');
    featureCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-10px) scale(1.02)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });
    
    // Add click effects to service items
    const serviceItems = document.querySelectorAll('.service-item');
    serviceItems.forEach(item => {
        item.addEventListener('click', function() {
            this.style.transform = 'scale(0.98)';
            setTimeout(() => {
                this.style.transform = 'scale(1)';
            }, 150);
        });
    });
    
    // Add typing effect to hero title
    const heroTitle = document.querySelector('.hero-content h2');
    if (heroTitle) {
        const text = heroTitle.textContent;
        heroTitle.textContent = '';
        let i = 0;
        
        function typeWriter() {
            if (i < text.length) {
                heroTitle.textContent += text.charAt(i);
                i++;
                setTimeout(typeWriter, 100);
            }
        }
        
        setTimeout(typeWriter, 1000);
    }
});

// Add scroll-based animations (removed problematic parallax effect)
window.addEventListener('scroll', function() {
    // Smooth scrolling behavior without content hiding
    const scrolled = window.pageYOffset;
    
    // Add subtle fade-in effect for sections as they come into view
    const sections = document.querySelectorAll('section');
    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.offsetHeight;
        const windowHeight = window.innerHeight;
        
        if (scrolled > sectionTop - windowHeight + 100) {
            section.style.opacity = '1';
            section.style.transform = 'translateY(0)';
        }
    });
});

// Add loading animation
window.addEventListener('load', function() {
    document.body.style.opacity = '0';
    document.body.style.transition = 'opacity 0.5s ease-in-out';
    
    setTimeout(() => {
        document.body.style.opacity = '1';
    }, 100);
});

// Contact Form Handler
document.addEventListener('DOMContentLoaded', function() {
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form data
            const formData = new FormData(contactForm);
            const name = formData.get('name');
            const email = formData.get('email');
            const message = formData.get('message');
            
            // Simulate saving to DynamoDB (in real implementation, this would call AWS API)
            console.log('Contact form submitted:', { name, email, message });
            
            // Show success message
            alert('Thank you for your message! In a real implementation, this would be saved to DynamoDB.');
            
            // Reset form
            contactForm.reset();
        });
    }
    
    // Visitor Counter (simulated)
    updateVisitorCounter();
});

// Simulate visitor counter (in real implementation, this would fetch from DynamoDB)
function updateVisitorCounter() {
    // Simulate visitor data
    const totalVisitors = Math.floor(Math.random() * 1000) + 500;
    const todayVisitors = Math.floor(Math.random() * 50) + 10;
    
    const totalElement = document.getElementById('totalVisitors');
    const todayElement = document.getElementById('todayVisitors');
    
    if (totalElement) {
        animateCounter(totalElement, totalVisitors);
    }
    if (todayElement) {
        animateCounter(todayElement, todayVisitors);
    }
}

// Animate counter numbers
function animateCounter(element, target) {
    let current = 0;
    const increment = target / 50;
    const timer = setInterval(() => {
        current += increment;
        if (current >= target) {
            current = target;
            clearInterval(timer);
        }
        element.textContent = Math.floor(current);
    }, 30);
}

// Add keyboard navigation
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeInfrastructureInfo();
    }
});

// Add some console messages for developers
console.log('🚀 AWS Terraform Learning Project');
console.log('📚 This website demonstrates AWS infrastructure with Terraform');
console.log('🔧 Built with: S3, CloudFront, WAF, DynamoDB, VPC');
console.log('💡 Check the source code to learn more!');
