report 50102 "4HC Product Wise Brand"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = ProductBrandRevenue;
    Caption = 'Product Wise Brand Profitability Report';
    dataset
    {
        dataitem("4HC Product Brand Buffer"; "4HC Product Brand Buffer")
        {
            DataItemTableView = sorting("Product Code", "Brand Code") order(ascending);
            column(ProductCode_4HCProductBrandBuffer; "Product Code")
            {
            }
            column(BrandCode_4HCProductBrandBuffer; "Brand Code")
            {
            }
            column(Revenue_4HCProductBrandBuffer; Abs(Revenue))
            {
            }
            column(Cost_4HCProductBrandBuffer; Abs(Cost))
            {
            }
            column(Profit; Abs(Revenue) - Abs(Cost))
            {
            }
            column(Gross_Profit_Margin; ProfitPrecentage)
            {
            }
            column(CompanyName; this.CompanyInformation.Name)
            {
            }
            column(ProductName; ProductName)
            {
            }
            column(BrandName; BrandName)
            {
            }
            column(ReportTitle; ReportTitleLbl)
            {
            }
            column(StartDate; StartDate)
            {
            }
            column(EndDate; EndDate)
            {
            }
            trigger OnAfterGetRecord()
            begin
                ProfitPrecentage := 0;
                if Revenue <> 0 then
                    ProfitPrecentage := ((Abs(Revenue) - Abs(Cost)) / Abs(Revenue)) * 100;
                ProductName := this.GetDimValueName(this.GeneralLederSetup."Shortcut Dimension 2 Code", "Product Code");
                BrandName := this.GetDimValueName(this.GeneralLederSetup."Shortcut Dimension 4 Code", "Brand Code")
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(StartDateFilter; StartDate)
                    {
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the start date.';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            if StartDate <> 0D then
                                EndDate := CalcDate('<CM>', StartDate);
                        end;
                    }
                    field(EndDateFilter; EndDate)
                    {
                        ToolTip = 'Specifies the end date.';
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                }
            }
        }
    }

    rendering
    {
        layout(ProductBrandRevenue)
        {
            Type = RDLC;
            LayoutFile = 'Reports\Layouts\ProductBrandRevenue.rdl';
        }
    }

    var
        ProductBrandBuffer: Record "4HC Product Brand Buffer";
        CompanyInformation: Record "Company Information";
        GeneralLederSetup: Record "General Ledger Setup";
        ProfitPrecentage: Decimal;
        ReportTitleLbl: Label 'Product Wise Brand Profitability Report';
        ProductName: Text[100];
        BrandName: Text[100];
        StartDate: Date;
        EndDate: Date;

    trigger OnPreReport()
    var
        RevenueGLEntry: Record "G/L Entry";
        CostGLEntry: Record "G/L Entry";
    begin
        CompanyInformation.Get();
        GeneralLederSetup.Get();
        if (StartDate = 0D) or (EndDate = 0D) then
            Error('specify the filters properly');
        RevenueGLEntry.SetCurrentKey("Entry No.", "G/L Account No.", "Posting Date");
        RevenueGLEntry.SetFilter("G/L Account No.", '2100005|2100015');
        RevenueGLEntry.SetRange("Posting Date", StartDate, EndDate);
        if RevenueGLEntry.FindSet() then
            repeat
                RevenueGLEntry.CalcFields("Shortcut Dimension 4 Code");
                ProductBrandBuffer.Reset();
                if ProductBrandBuffer.Get(RevenueGLEntry."Global Dimension 2 Code", RevenueGLEntry."Shortcut Dimension 4 Code") then begin
                    ProductBrandBuffer.Revenue += RevenueGLEntry.Amount;
                    ProductBrandBuffer.Modify();
                end
                else begin
                    ProductBrandBuffer.Init();
                    ProductBrandBuffer."Product Code" := RevenueGLEntry."Global Dimension 2 Code";
                    ProductBrandBuffer."Brand Code" := RevenueGLEntry."Shortcut Dimension 4 Code";
                    ProductBrandBuffer.Revenue := RevenueGLEntry.Amount;
                    ProductBrandBuffer.Insert();
                end;
            until RevenueGLEntry.Next() = 0;

        CostGLEntry.SetCurrentKey("Entry No.", "G/L Account No.", "Posting Date");
        CostGLEntry.SetFilter("G/L Account No.", '2300005');
        CostGLEntry.SetRange("Posting Date", StartDate, EndDate);
        if CostGLEntry.FindSet() then
            repeat
                CostGLEntry.CalcFields("Shortcut Dimension 4 Code");
                ProductBrandBuffer.Reset();
                if ProductBrandBuffer.Get(CostGLEntry."Global Dimension 2 Code", CostGLEntry."Shortcut Dimension 4 Code") then begin
                    ProductBrandBuffer.Cost += CostGLEntry.Amount;
                    ProductBrandBuffer.Modify();
                end
                else begin
                    ProductBrandBuffer.Init();
                    ProductBrandBuffer."Product Code" := CostGLEntry."Global Dimension 2 Code";
                    ProductBrandBuffer."Brand Code" := CostGLEntry."Shortcut Dimension 4 Code";
                    ProductBrandBuffer.Cost := CostGLEntry.Amount;
                    ProductBrandBuffer.Insert();
                end;
            until CostGLEntry.Next() = 0;
    end;

    local procedure GetDimValueName(DimensionCode: Code[20]; DimensionValueCode: Code[20]): Text[100]
    var
        DimensionValue: Record "Dimension Value";
    begin
        if DimensionValue.Get(DimensionCode, DimensionValueCode) then
            exit(DimensionValue.Name);

        exit('');
    end;

    trigger OnPostReport()
    begin
        ProductBrandBuffer.DeleteAll();
    end;
}