describe('Add to Cart', () => {
  it('should visit root', () => {
    cy.visit('/');
  });

  it("There is 2 products on the page", () => {
    cy.visit("/");
    cy.get(".products article").should("have.length", 2);
  });
  
  it("Should add a product to the cart and update cart count", () => {
    cy.visit('/');
    // Ensure products are visible
    cy.get(".products article").should("have.length.at.least", 1);

    // Click "Add to Cart" button for the first product
    cy.get(".products article").first().find(".btn").click();

    // Verify cart count increased
    cy.get(".nav-link").contains("My Cart").should("contain", "(1)");
  });
});