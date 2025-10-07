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
        <p><strong>S3:</strong> Static website hosting with simplified configuration for learning</p>
        <p><strong>CloudFront:</strong> Global CDN with Origin Access Identity (OAI) for secure S3 access</p>
        <p><strong>DynamoDB:</strong> NoSQL database for contact form data and user sessions</p>
        <p><strong>WAF:</strong> Web Application Firewall integrated with CloudFront for security</p>
        <p><strong>Terraform:</strong> Simplified Infrastructure as Code for learning AWS fundamentals</p>
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
            this.style.transform = 'translateY(-5px)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
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
});

// Add scroll-based animations
window.addEventListener('scroll', function() {
    // Add subtle fade-in effect for sections as they come into view
    const sections = document.querySelectorAll('section');
    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.offsetHeight;
        const windowHeight = window.innerHeight;
        
        if (window.pageYOffset > sectionTop - windowHeight + 100) {
            section.style.opacity = '1';
            section.style.transform = 'translateY(0)';
        }
    });
});

// API Configuration - This will be replaced with actual API Gateway URL during deployment
const API_BASE_URL = 'https://YOUR_API_GATEWAY_ID.execute-api.us-east-1.amazonaws.com/dev';

// Contact Form Handler with Fallback
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
                // Try API Gateway endpoint first
                const response = await fetch(`${API_BASE_URL}/contact`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ name, email, message })
                });
                
                if (response.ok) {
                    const result = await response.json();
                    alert('Thank you for your message! It has been saved successfully.');
                    contactForm.reset();
                } else {
                    throw new Error(`API Error: ${response.status}`);
                }
            } catch (error) {
                console.error('API Error:', error);
                
                // Fallback: Store in localStorage for demo purposes
                try {
                    const submissions = JSON.parse(localStorage.getItem('contactSubmissions') || '[]');
                    submissions.push({
                        name: name,
                        email: email,
                        message: message,
                        timestamp: new Date().toISOString()
                    });
                    localStorage.setItem('contactSubmissions', JSON.stringify(submissions));
                    
                    alert('Thank you for your message! (Stored locally for demo purposes)');
                    contactForm.reset();
                } catch (fallbackError) {
                    console.error('Fallback Error:', fallbackError);
                    alert('Sorry, there was an error submitting your message. Please try again.');
                }
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
console.log('📚 This website demonstrates simplified AWS infrastructure with Terraform');
console.log('🔧 Built with: S3, CloudFront (OAI), WAF, DynamoDB, VPC');
console.log('💡 Simplified setup for learning AWS and Terraform fundamentals!');
