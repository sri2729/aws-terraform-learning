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

// API Configuration
const API_BASE_URL = 'https://t2engatoq6.execute-api.us-east-1.amazonaws.com/dev';

// Contact Form Handler with Real API
document.addEventListener('DOMContentLoaded', function() {
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            // Get form data
            const formData = new FormData(contactForm);
            const name = formData.get('name');
            const email = formData.get('email');
            const message = formData.get('message');
            
            // Show loading state
            const submitBtn = contactForm.querySelector('.submit-btn');
            const originalText = submitBtn.textContent;
            submitBtn.textContent = 'Sending...';
            submitBtn.disabled = true;
            
            try {
                // Call API Gateway endpoint
                const response = await fetch(`${API_BASE_URL}/contact`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ name, email, message })
                });
                
                const result = await response.json();
                
                if (response.ok) {
                    alert('Thank you for your message! It has been saved successfully.');
                    contactForm.reset();
                } else {
                    throw new Error(result.error || 'Failed to submit form');
                }
            } catch (error) {
                console.error('Error submitting form:', error);
                alert('Sorry, there was an error submitting your message. Please try again.');
            } finally {
                // Reset button state
                submitBtn.textContent = originalText;
                submitBtn.disabled = false;
            }
        });
    }
    
});

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
