describe('Navigation', () => {
  it('should visit root', () => {
    cy.visit('/');
  });

  it("There is products on the page", () => {
    cy.visit("/");
    cy.get(".products article").should("be.visible");
  });

  it("There is 2 products on the page", () => {
    cy.visit("/");
    cy.get(".products article").should("have.length", 2);
  });

  it("Should navigate to product detail page when clicking on a product", () => {
    cy.visit("/");
    cy.get(".products article").first().click(); //Click the first product
    cy.url().should("include", "/products/"); // Check if URL changes
    cy.get(".product-detail").should("be.visible"); // Check if product detail is shown
  });
});